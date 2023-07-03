time=$(date "+%Y%m%d-%H%M%S")
git pull
git add .
git commit -m "${time}"
git push