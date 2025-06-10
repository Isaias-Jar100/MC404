.data
input_file:     .asciz "image.pgm"
newline:        .byte 10

.bss
header_buffer:  .space 64          # Espaço para cabeçalho
width_str:      .space 8
height_str:     .space 8
image_buffer:   .space 4096        # Espaço para os pixels (64x64)
message_buffer: .space 512   # Espaço para até 512 caracteres extraídos
