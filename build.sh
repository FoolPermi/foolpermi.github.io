echo git checkout develop
echo "start build"
echo "remove public folder..."
rm -rf public
echo "public folder removed..."
git add source/*
git add ./build.sh
git commit -m "add file..."
git checkout
git push
echo "classic..."
hexo g --config _config_classic.yml
echo "dark..."
hexo g --config _config_dark.yml
echo "light..."
hexo g --config _config_light.yml
echo "white..."
hexo g --config _config_white.yml
echo "copy public folder..."
rm -rf ~/Documents/Blogs/tmp
mkdir ~/Documents/Blogs/tmp
cp -r public/ ~/Documents/Blogs/tmp
rm -r public/
git checkout 
echo "git switch to master..."
git checkout master
echo "remove master public folder..."
cp -r ~/Documents/Blogs/tmp/  ./
echo "hexo deploy..."
git add cactus-classic/* cactus-white/* cactus-light/* cactus-dark/*
git commit -m "updated at `date +%Y-%m-%d %r`"
echo "git push to master..."
git pull
git push
echo "git switch to develop..."
git checkout develop
rm -rf ~/Documents/Blogs/tmp

