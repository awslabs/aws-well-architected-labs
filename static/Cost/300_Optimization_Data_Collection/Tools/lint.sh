#!/bin/bash
folder=$(pwd)
code_path=$(git rev-parse --show-toplevel)/static/Cost/300_Optimization_Data_Collection/Code

echo "linting CFN templates"
for template in $code_path/*.yaml; do
  rel_path=$(realpath $template --relative-to="$(pwd)")
  echo "Linting $rel_path"
  echo "$(cfn-lint  --ignore-checks W3005 -- $rel_path && echo ' OK')" | awk '{ print "\t" $0 }'
done

cd $pwd


