#!/usr/bin/env bash
set -o errexit
set -o nounset
# ----------------------------------------------------------------------------
#  sofy: um programa de linha de comando para reproduzir vídeos do YouTube, em ASCII
# ----------------------------------------------------------------------------
# Dependências:
# youtube-dl
# mpv
# ffmpeg
# ----------------------------------------------------------------------------
# URL das lives de lofy
VD1="https://www.youtube.com/live/jfKfPfyJRdk"
VD2="https://www.youtube.com/live/rUxyKA_-grg"
VD3="https://www.youtube.com/live/4xDzrJKXOOY"
# ----------------------------------------------------------------------------
# Cores
green=`tput setaf 2 ; tput bold`
red=`tput setaf 1 ; tput bold`
bold=`tput sgr0 ; tput bold`
reset=`tput sgr0`
# ----------------------------------------------------------------------------
# Função para verificar dependências
check_dependencies() {
    local dependencies=("youtube-dl" "mpv" "ffmpeg")

    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            printf "\n${red}Erro: A dependência '$dep' não está instalada!${reset}\n\n"
            exit 1
        fi
    done
}
# Chama a função para verificar dependências
check_dependencies
# ----------------------------------------------------------------------------
# Função para testar a URL
url_test() {
  while [[ -z "${URL-}" ]]; do
    printf "\n${red}Erro: URL não informada!${reset}\n"
    printf "${bold}Informe a URL do vídeo:${reset} "
    read -r URL
  done
}

# Função para testar o termo de pesquisa
search_test() {
  while [[ -z "${SEARCH-}" ]]; do
    printf "\n${red}Erro: termo de pesquisa não informado!${reset}\n"
    printf "${bold}Informe o que deseja pesquisar:${reset} "
    read -r SEARCH
  done
}
# ----------------------------------------------------------------------------
# Controles
short() {
echo "${bold}Lista de atalhos:${reset}"
  cat << SRT
    P : Pausar / Retomar
    M : Mudo
    0 : Aumenta o volume
    9 : Diminui o volume
    
    Para sair, aperte a tecla "Q"
SRT
}
# ----------------------------------------------------------------------------
# Menu principal
menu() {
    echo -e "${green} 1)${bold} Rádio com vídeo (ASCII)"
    echo -e "${green} 2)${bold} Rádio sem vídeo"
    echo -e "${green} 3)${bold} Tocar a partir de uma URL"
    echo -e "${green} 4)${bold} Tocar a partir de uma pesquisa"
    echo -e "\nPor favor, escolha uma opção do menu ou aperte Enter para sair.${reset}"
    read opt
  while [ opt != '' ]
  do
    if [[ $opt = "" ]]; then
      exit;
    else
	      case $opt in
	      1) clear;
	      echo -e "${red}Rádio com vídeo (ASCII):${reset}\n";
	      radio;
	      ;;

	      2) clear;
	      echo -e "${red}Rádio sem vídeo:${reset}\n";
	      radio_novid;
	      ;;

	      3) clear;
	      echo -e "${red}A partir de uma URL:${reset}\n";
	      by_url;
	      ;;
	      
	      4) clear;
	      echo -e "${red}A partir de uma pesquisa:${reset}\n";
	      by_search;
	      ;;

	      *)clear;
	      echo -e "${red}Escolha uma opção do menu!${reset}\n";
	      menu;
	      ;;
	      esac
	    fi
	  done
}
# ----------------------------------------------------------------------------
menu_radio() {
    echo -e "${green} 1)${bold} Rádio relax/study to"
    echo -e "${green} 2)${bold} Rádio sleep/chill to"
    echo -e "${green} 3)${bold} Rádio chill/game to"
    echo -e "\nPor favor, escolha uma opção do menu ou aperte Enter para sair.${reset}"
}

sub_menu() {
    echo -e "${green} 1)${bold} Com vídeo (ASCII)"
    echo -e "${green} 2)${bold} Com vídeo (normal)"
    echo -e "${green} 3)${bold} Sem vídeo"
    echo -e "\nPor favor, escolha uma opção do menu ou aperte Enter para sair.${reset}"
}

head1(){
	      echo -e ${red}"\nCarregando, aguarde...${reset}"
}

head2() {
echo -e "${bold}\nInforme o que deseja pesquisar.${reset}"
	      read SEARCH
	      search_test
	      echo -e ${red}"\nCarregando, aguarde...${reset}"
}

head3() {
echo -e "${bold}\nInforme a URL do vídeo.${reset}"
	      read URL
	      url_test
	      URL=${URL// /+}
	      echo -e ${red}"\nCarregando, aguarde...${reset}"
}
# ----------------------------------------------------------------------------
# Início do programa em si
radio() {
    menu_radio
    read sub1
  while [ sub1 != '' ]
  do
    if [[ $sub1 = "" ]]; then
      exit;
    else
	      case $sub1 in
	      1) head1
	      youtube-dl -i -q --no-warnings "$VD1" -f best -o - | mpv --vo=tct --really-quiet - && clear
	      exit 0
	      ;;

	      2) head1
	      youtube-dl -i -q --no-warnings "$VD2" -f best -o - | mpv --vo=tct --really-quiet - && clear
	      exit 0
	      ;;
	      
	      3) head1
	      youtube-dl -i -q --no-warnings "$VD3" -f best -o - | mpv --vo=tct --really-quiet - && clear
	      exit 0
	      ;;

	      *)clear;
	      echo -e "${red}Escolha uma opção do menu!${reset}\n";
	      radio;
	      ;;
	      esac
	    fi
	  done
}
# ----------------------------------------------------------------------------
radio_novid() {
    menu_radio
    read sub2
  while [ sub2 != '' ]
  do
    if [[ $sub2 = "" ]]; then
      exit;
    else
	      case $sub2 in
	      1) head1
	      short
	      youtube-dl -i -q --no-warnings "$VD1" -f best -o - | mpv --no-video --really-quiet -
	      clear
	      exit 0
	      ;;

	      2) head1
	      short
	      youtube-dl -i -q --no-warnings "$VD2" -f best -o - | mpv --no-video --really-quiet -
	      clear
	      exit 0
	      ;;
	      
	      3) head1
	      short
	      youtube-dl -i -q --no-warnings "$VD3" -f best -o - | mpv --no-video --really-quiet -
	      clear
	      exit 0
	      ;;

	      *)clear;
	      echo -e "${red}Escolha uma opção do menu!${reset}\n";
	      radio_novid;
	      ;;
	      esac
	    fi
	  done
}
# ----------------------------------------------------------------------------
by_url() {
    sub_menu
    read sub3
  while [ sub3 != '' ]
  do
    if [[ $sub3 = "" ]]; then
      exit;
    else
	      case $sub3 in
	      1) head3
	      youtube-dl --yes-playlist -i -q --no-warnings "$URL" -f best -o - | mpv --vo=tct --really-quiet - && clear
	      exit 0
	      ;;
	      
	      2) head3
	     youtube-dl --yes-playlist -i -q --no-warnings "$URL" -f best -o - | mpv --really-quiet -
	      kill $PPID
	      clear
	      exit 0
	      ;;
	      
	      3) head3
	      short
	      youtube-dl --yes-playlist -i -q --no-warnings "$URL" -f best -o - | mpv --no-video --really-quiet -
	      clear
	      exit 0
	      ;;

	      *)clear;
	      echo -e "${red}Escolha uma opção do menu!${reset}\n";
	      by_url;
	      ;;
	      esac
	    fi
	  done
}
# ----------------------------------------------------------------------------
by_search() {
    sub_menu
    read sub4
  while [ sub4 != '' ]
  do
    if [[ $sub4 = "" ]]; then
      exit;
    else
	      case $sub4 in
	      1) head2
	      youtube-dl --yes-playlist -i -q --no-warnings ytsearch:"$SEARCH" -f best -o - | mpv --vo=tct --really-quiet - && clear
	      exit 0
	      ;;
	      
	      2) head2
	      search_test
	      youtube-dl --yes-playlist -i -q --no-warnings ytsearch:"$SEARCH" -f best -o - | mpv --really-quiet -
	      kill $PPID
	      clear
	      exit 0
	      ;;
	      
	      3) head2
	      short
	      youtube-dl --yes-playlist -i -q --no-warnings ytsearch:"$SEARCH" -f best -o - | mpv --no-video --really-quiet -
	      clear
	      exit 0
	      ;;

	      *)clear;
	      echo -e "${red}Escolha uma opção do menu!${reset}\n";
	      by_search;
	      ;;
	      esac
	    fi
	  done
}
clear
menu
