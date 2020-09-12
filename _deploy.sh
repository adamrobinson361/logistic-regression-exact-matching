#!/bin/bash

# Configure your name and email if you have not done so

git config --global user.email "travis-ci@travis-ci.org"
git config --global user.name "travis-ci"

# Ensure that the book will only be updated when the build is 
# triggered from the master branch.

[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

[ "${TRAVIS_PULL_REQUEST}" != "false" ] && exit 0

# Clone the repository to the book-output directory

git clone -b gh-pages \
  https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git \
  book-output

# Copy locally built *.html files into 
cp -r Outputs/* book-output
mv book-output/report.html book-output/index.html


# Create .nojekyll file to prevent git from trying to build
# html pages with jekyll.

touch book-output/.nojekyll

# Add the locally built files to a commit and push

cd book-output
ls
git add . -f || true
git commit -m "Automatic build update" || true
git push -f origin gh-pages || true
