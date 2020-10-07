#!/bin/bash

cd /home/nick/workspaces/school/ps4-games

wget -O ps4-games.json "https://store.playstation.com/valkyrie-api/en/US/999/container/STORE-MSF77008-GAMESFREETOPLAY?price=0-0&platform=ps4&size=30&bucket=games&start=0"

#Free-to-Play, not teen or mature
cat ps4-games.json | jq '
    .included[]|.attributes | 
        select(."content-rating") |
         select(."content-rating".url | test(".(t|m).png") | not) |
            { name:.name, 
                url:."content-rating".url, 
                genres:.genres, 
                descr:."long-description", 
                media: ."media-list"."screenshots",
                type: ."game-content-type",
                releaseDate: ."release-date"
            } 
' | jq -s . > games.json 
# slurp the selected json to make it a proper json array