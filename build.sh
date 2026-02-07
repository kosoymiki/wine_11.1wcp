#!/usr/bin/env bash
set -euxo pipefail

#############################################
# Build Wine‑tkg ARM64EC + Staging + Proton
#############################################

WORK="$PWD/build"
SRC="$WORK/src"
HOST="$WORK/host"
INSTALL="$WORK/install"
WCP_OUT="$PWD"

# Clean work dirs
rm -rf "$WORK"
mkdir -p "$SRC" "$HOST" "$INSTALL"

# ===============================
# 1. Clone sources
# ===============================

echo ">>> Cloning Wine 11.1"
git clone https://gitlab.winehq.org/wine/wine.git "$SRC/wine-git"
(
  cd "$SRC/wine-git"
  git fetch --tags
  git checkout wine-11.1
)

echo ">>> Cloning Wine Staging"
git clone https://gitlab.winehq.org/wine/wine-staging.git "$SRC/wine-staging-git"

echo ">>> Cloning wine-tkg git"
git clone https://github.com/Frogging-Family/wine-tkg-git.git "$SRC/wine-tkg-git"

# ===============================
# 2. Prepare TKG customization
# ===============================

cd "$SRC/wine-tkg-git"

# Copy example customization
cp wine-tkg-profiles/advanced-customization.cfg customization.cfg

# Enable key features
sed -i 's/^_use_staging=.*/_use_staging="true"/' customization.cfg
sed -i 's/^_use_esync=.*/_use_esync="true"/' customization.cfg
sed -i 's/^_use_fsync=.*/_use_fsync="true"/' customization.cfg
sed -i 's/^_use_GE_patches=.*/_use_GE_patches="true"/' customization.cfg
sed -i 's/^_protonify=.*/_protonify="true"/' customization.cfg
sed -i 's/^_proton_rawinput=.*/_proton_rawinput="true"/' customization.cfg
sed -i 's/^_proton_fs_hack=.*/_proton_fs_hack="true"/' customization.cfg

# Ensure scripts are executable
chmod +x wine-tkg-scripts/*.sh

# Run prepare
yes "" | ./wine-tkg-scripts/prepare.sh

# Go back to main src
cd "$SRC"

# ===============================
# 3. Build Wine Host Tools
# ===============================

echo ">>> Building host tools"
mkdir -p "$HOST/build"
cd "$HOST/build"

"$SRC/wine-git/configure" --disable-tests --enable-win64
make __tooldeps__ -j$(nproc)

# ===============================
# 4. Build Wine ARM64EC
# ===============================

echo ">>> Building Wine ARM64EC"
mkdir -p "$WORK/build-arm64ec"
cd "$WORK/build-arm64ec"

# Cross toolchain environment
export CC=aarch64-w64-mingw32-clang
export CXX=aarch64-w64-mingw32-clang++
export WINDRES=aarch64-w64-mingw32-windres

export CFLAGS="-O3 -march=armv8.2-a+fp16+dotprod"
export CXXFLAGS="$CFLAGS"
export CROSSCFLAGS="$CFLAGS -mstrict-align"

"$SRC/wine-git/configure" \
  --host=aarch64-w64-mingw32 \
  --enable-win64 \
  --with-wine-tools="$HOST/build" \
  --with-mingw=clang \
  --enable-archs=i386,arm64ec,aarch64 \
  --disable-tests \
  --with-x \
  --with-vulkan \
  --with-freetype \
  --with-pulse \
  --without-wayland \
  --without-gstreamer \
  --without-cups \
  --without-sane \
  --without-oss

make -j$(nproc)

# ===============================
# 5. Install to DESTDIR
# ===============================

echo ">>> Installing Wine build"
rm -rf "$INSTALL"
make DESTDIR="$INSTALL" install

# ===============================
# 6. Package as WCP
# ===============================

echo ">>> Packaging WCP"

WCP_DIR="$WORK/wcp"
rm -rf "$WCP_DIR"
mkdir -p "$WCP_DIR/bin" "$WCP_DIR/lib/wine" "$WCP_DIR/share"

cp -a "$INSTALL"/usr/bin/* "$WCP_DIR/bin/" 2>/dev/null || true
cp -a "$INSTALL"/usr/lib/wine* "$WCP_DIR/lib/wine/" 2>/dev/null || true
cp -a "$INSTALL"/usr/share/* "$WCP_DIR/share/" 2>/dev/null || true

# Symlink standard wine
(
  cd "$WCP_DIR/bin"
  ln -sf wine64 wine || true
)

# Fix permissions
find "$WCP_DIR/bin" -type f -exec chmod +x {} \;
find "$WCP_DIR/lib/wine" -name "*.so*" -exec chmod +x {} \;

# Write info.json
cat > "$WCP_DIR/info.json" << 'EOF'
{
  "name": "Wine-11.1-Staging-TKG-ARM64EC",
  "version": "11.1",
  "arch": "arm64",
  "variant": "staging+tkg",
  "features": ["staging","fsync","esync","vulkan","proton"]
}
EOF

# Write env.sh
cat > "$WCP_DIR/env.sh" << 'EOF'
#!/bin/sh
export WINEDEBUG=-all
export WINEESYNC=1
export WINEFSYNC=1
EOF
chmod +x "$WCP_DIR/env.sh"

# Create final archive
tar -cJf "$WCP_OUT/${WCP_NAME:-wine-tkg-arm64ec.wcp}" -C "$WCP_DIR" .

echo ">>> WCP created at $WCP_OUT/${WCP_NAME:-wine-tkg-arm64ec.wcp}"