 yc compute instance create --name reddit-app \
          --hostname reddit-app  \
          --core-fraction=5  \
          --memory=2   \
          --create-boot-disk image-family=reddit-full,size=14GB   \
          --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4  \
          --metadata serial-port-enable=1
