#!/data/data/com.termux/files/usr/bin/bash

while true
do
    clear
    echo "=============================="
    echo " TECH SKILLS HUB INSTALLER"
    echo "=============================="
    echo ""
    echo "1. Apps"
    echo "2. Drivers"
    echo "0. Exit"
    echo ""

    read -p "Choose: " choice

    case $choice in
        1)
            echo "Apps menu coming soon..."
            read -p "Press Enter..."
            ;;
        2)
            echo "Driver Center coming soon..."
            read -p "Press Enter..."
            ;;
        0)
            exit
            ;;
        *)
            echo "Invalid option!"
            read -p "Press Enter..."
            ;;
    esac
done
