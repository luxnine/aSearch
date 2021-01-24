echo "Qual nome do anime?"
read anime
urlparse=$(echo $anime | sed 's/ /+/g')
query="https://www.google.com/search?q=$urlparse+goyabu&tbm=vid"

echo $(clear)

read mediaUrl <<<$(curl "$query" --header "Accept: text/html" --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -s | awk -F '<div class="IsZvec">' '{split($2, a, "href=\"");split(a[2], b, "\"");printf b[1]}')
read media <<<$(curl -v --stderr - $mediaUrl gpage | awk -F '{type: "video/mp4", label:' '{split($2,a,"\"");printf a[4]}')
echo $(celluloid $media)
