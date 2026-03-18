nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin loader.asm    # For our Loader file
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
# Have to add the loader.bin file into our img file
# this can be done by count=5 and seek=1 (seeks 1 byte sector)
# and conv=notrunc (so to not truncate previous data)
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
