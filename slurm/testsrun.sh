#!/bin/bash

for group in nodes himem viz gpu; do
  for node in $(act_nodenames -g $group); do
    echo "Testing srun on $node"
      srun --pty --nodelist=$node hostname
  done
done

