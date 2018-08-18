echo git checkout develop
echo "start build"
echo "remove public folder..."
rm -rf ./public
echo "public folder removed..."
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
cp ./public ~/Documents/Blogs/tmp
echo "git stash..."
git stash
echo "git switch to master..."
git checkout master
echo "remove master public folder..."
rm -rf public
mkdir public
echo "copy to public"
cp ~/Documents/Blogs/tmp/ public
echo "hexo deploy..."
git commit -a
echo "git push..."
git pull
git push
echo "git switch to develop..."
git checkout develop
git stash clear
rm -rf ~/Documents/Blogs/tmp

