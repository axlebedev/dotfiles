cd $1  
branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$branch" != "HEAD" ]; \
then
    # skip 'feature/' at start
    echo ${branch}
    exit 0
fi

echo $(git log --pretty=format:'%h' -n 1)
