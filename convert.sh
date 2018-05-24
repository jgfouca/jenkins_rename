#! /bin/bash

for line in $(cat SON_Nodes.csv); do
    current_name=$(echo $line | cut -d , -f 1)
    new_name=$(echo $line | cut -d , -f 2)
    current_label=$(echo $line | cut -d , -f 3)
    new_label=$(echo $line | cut -d , -f 4)

    if [[ "$current_name" != "$new_name" ]]; then
        mv nodes/$current_name nodes/$new_name
        sed -i nodes/$new_name "s:<name>(.*)$current_name(.*)</name>:<name>\1$new_name\2</name>:g"

        for item in $(grep -R $current_name *); do
            filename=$(dirname $item)
            if [[ "$filename" == "config.xml" ]]; then
                sed -i $item "s:<assignedNode>(.*)$current_name(.*)</assignedNode>:<assignedNode>\1$new_name\2</assignedNode>:g"
            fi
        done
    fi

    if [[ "$current_label" != "$new_label" ]]; then
        for item in $(grep -R $current_label *); do
            filename=$(dirname $item)
            if [[ "$filename" == "config.xml" ]]; then
                sed -i $item "s:<label>(.*)$current_label(.*)</label>:<label>\1$new_label\2</label>:g"
                sed -i $item "s:<assignedNode>(.*)$current_label(.*)</assignedNode>:<assignedNode>\1$new_label\2</assignedNode>:g"
            fi
        done
    fi
done
