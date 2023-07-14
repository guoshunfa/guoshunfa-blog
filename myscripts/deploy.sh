# 清空git库内容
rm -rf public
npm run build
cd public
git init
git remote add origin https://github.com/guoshunfa/guoshunfa-blog-page.git
git add .
git commit -m "deleted all files"
git push origin master:master --force
