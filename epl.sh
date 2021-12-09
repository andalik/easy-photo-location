!/bin/bash

# Validar fornecimento de arquivo via linha de comando
FILE="${1}"
if [ -z "${FILE}" ]; then 
    echo "ERRO: Arquivo de imagem não informado!"; 
    exit 1; 
fi
if [ ! -f "${FILE}" ]; then 
    echo "ERRO: Arquivo de imagem não encontrado!"; 
    exit 1; 
fi

# Verificar existencia de coordenadas GPS no arquivo fornecido
if [ ! "$(exiftool "${FILE}" | grep "GPS Latitude")" ]; then 
    echo "INFO: Coordenadas GPS inexistentes"; 
    exit 1; 
fi

# Extrair e formatar coordenadas GPS (latitude e longitude)
LAT=$(exiftool "${FILE}" \
          | grep Latitude \
          | grep deg \
          | cut -d : -f 2 \
          | sed -e 's/deg/°/g' -e 's/ //g'
)

LON=$(exiftool "${FILE}" \
          | grep Longitude \
          | grep deg \
          | cut -d : -f 2 \
          | sed -e 's/deg/°/g' -e 's/ //g'
)

# Compor URL de acesso ao Google Maps e abrir navegador 
xdg-open https://www.google.com/maps/place/"${LAT}${LON}" &

exit
