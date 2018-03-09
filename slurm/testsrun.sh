#!/bin/bash

#for group in nodes himem viz gpu; do
for group in himem viz gpu; do
  for node in $(act_nodenames -g $group); do
    echo "Testing srun on $node"
      srun --pty -p $group --nodelist=$node hostname
  done
done

