---
layout: post
title:  "Estrenem nou blog! Warning: Post tècnic :-P"
categories: [ news ]
image: assets/images/banner_08-11-2024.jpg
date: 2024-11-08 10:00:00 +0000
---
Després de mooolt de temps amb el meu blog [CatalanInJapan a Blogspot](https://catalaninjapan.blogspot.com/p/start.html), he decidit traslladar-lo a alguna cosa més moderna (tampoc massa, no us penseu).

> Avís a navegants: Aquesta entrada serà una mica més tècnica de l'habitual.

El nou blog està desenvolupat amb **Jekyll**, una eina per crear static sites que puc hospedar a **github-pages** i per tant **no gastar-me ni un duro**. Està basada en Ruby, que no m'agrada gens, però un cop ho tens funcionant va de conya! I gratis! Ja sabeu que soc com el meu germà ;-D

No ha estat excessivament complicat fer la migració des de Blogger fins a Jekyll, però té el seu què.

--- 

Per fer la migració, primer necessitem [exportar una còpia de seguretat des de Blogger](https://support.google.com/blogger/answer/97416).

Un cop tenim el fitxer, instal·lem l'eina de migració:

```
sudo gem install jekyll-import
```

Ara executem la migració:

```bash
jekyll-import blogger --source ../blogger-catalan_in_japan-backup-11-08-2024.xml --no-blogger-info --replace-internal-link --comments
```

Quin problema hi ha? Que el jekyll import literalment genera fitxers html. Bàsicament un format molt incòmode de tractar, ja que un dels aventatges de Jekyll és que fa servir Markdown pels posts. Si, Markdown, igual que els READMEs.

El que he fet ha sigut desenvolupar un petit script en bash que s'encarregui de la conversió. Bé, realment ho ha fet GPT, però... què més dóna!

```
#!/bin/bash

# Directory containing the Blogger HTML files
SOURCE_DIR="_posts"

# Loop through all HTML files in the source directory
for file in $(ls "$SOURCE_DIR" | grep md); do
    file=_posts.new/$file
    # Define output Markdown file
    output="${file}.md"
    
    # Start creating new front matter
    echo "---" > "$output"
    
    # Read the original file line by line
    while IFS= read -r line || [[ -n $line ]]; do
        case "$line" in
            *title:*) 
                title=$(echo "$line" | sed 's/^.*title: *\(.*\)$/\1/')
                echo "title: \"$title\"" >> "$output"
                ;;
            *date:*)
                date=$(echo "$line" | sed 's/^.*date: *\(.*\)$/\1/')
                echo "date: $date" >> "$output"
                ;;
            *tags:*)
                echo "categories: [news]" >> "$output"
                ;;
            *thumbnail:*)
                thumbnail=$(echo "$line" | sed 's/^.*thumbnail: *\(.*\)$/\1/')
                echo "image: $thumbnail" >> "$output"
                ;;
            *else)
                echo "---" >> "$output"
                break
                ;;
        esac
    done < "$file"
    
    # Append remaining content below front matter
    awk '/^<\!--/{p=1; next} p' "$file" >> "$output"
    
    echo "Converted $file to $output"
done
```

Simplement cridem l'script, i ens retornarà els fitxers convertits en un perfecte Markdown, amb la capçalera correcta:

```bash
./script.sh
```

I fins aquí! A partir d'aquest punt el que ens pot interessar és posar imatges de capçalera, ja que amb blogger no hi eren. El que he fet ha sigut fer un replace des del VisualStudio per afegir una línia "image" amb una imatge "legacy" del blog anterior, genèrica per tots els posts. Si algun dia em poso a modificar un per un per posar alguna foto, doncs bueno... serà que estic molt motivat i m'avorreixo molt.

I això és tot! En el proper post explicaré notícies!!