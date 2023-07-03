# 清空git库内容
rm -rf public
git clone https://github.com/guoshunfa/guoshunfa-blog-page.git public
cd public
git rm * -r
git commit -m "deleted all files"
git push
# 将新内容提交
cd ..
hexo generate
cd public
echo www.guoshunfa.com > CNAME
git add .
git commit -m "deploy commit"
git push

rm -rf public