function rdp
    read -P "IP : " ip
    read -P "User : " user
    read -s -P "Mot de passe : " pass
    echo
    xfreerdp /grab-keyboard /v:$ip /u:$user /p:$pass /size:100% /dynamic-resolution /gfx:AVC444,progressive:on
end
