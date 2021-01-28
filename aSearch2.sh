#!/bin/bash

echo $(clear)
printf "Qual nome do anime?\n> "
read anime
urlparse=$(echo $anime | sed 's/ /+/g')
query="https://www.google.com/search?q=$urlparse+site%3Agoyabu.com&tbm=vid"

read rawdata <<<$(curl -v --stderr - "$query"  "Accept: text/html" --user-agent "Mozilla/5.0 (Macintosh;atackl Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -s | awk -F '<div class=\"g\">' '{for(i=2;i<12;i++){ split($i,a,"<div class=\"yuRUbf\">");split(a[2],b,"<a href=\"");split(b[2],c,"\"");split(b[2], d, "<div style=\"margin-left:125px\">");split(d[2], e, "<span>");split(e[2], f, "</span>");ss = f[1];gsub("\\.\\.\\.", "", ss);gsub(/[[:blank:]–.,:;-]/,"+",ss);gsub("&nbsp", "", ss);gsub("<em>", "", ss);gsub("</em>", "", ss);if(ss)printf "%s;%s ", ss, c[1]}}')


lArr=(${rawdata})

echo "Qual episodio deseja ver?"
cont=0
for i in ${lArr[@]}
do  
    echo "[$cont] $i" | sed -r 's/[+,;]+/ /g'
    ((cont++))
done
printf "\n> "
read index


mediaUrl="${lArr[$index]##*;}"

echo $mediaUrl
read media <<<$(curl -v --stderr - $mediaUrl --header "Accept: text/html" --user-agent "Mozilla/5.0 (Macintosh;atackl Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" | awk -F '{type: "video/mp4", label:' '{split($2,a,"\"");printf a[4]}')
#printf a[4]}')
echo $media

if [[ -z "$media" ]]; then
   echo 'Erro ao capturar video do site, tentando usar outro metodo...'
   read rawmedia2 <<<$(curl -v --stderr - $mediaUrl --header "Accept: text/html" --user-agent "Mozilla/5.0 (Macintosh;atclearackl Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -s | awk -F 'type: "video/mp4"' '{split($2,a,"\"");if(a[4]) printf "%s ", a[4]}')
    media2Arr=(${rawmedia2})
    printf "Qual qualidade voce deseja?\n[0] HD\n[1] SD\n> "
    read resol
    media2=${media2Arr[$resol]}
    echo $media2
    echo $(celluloid $media2)
else
    echo $(celluloid $media)
fi
