resource "aws_efs_file_system" "noteapp_volume" {
  creation_token = "noteapp_volume"

  tags = {
    Name = "NoteApp EFS Volume."
  }
}

resource "aws_efs_mount_target" "noteapp_volume_mount" {
  for_each        = local.public_subnet_map
  file_system_id  = aws_efs_file_system.noteapp_volume.id
  subnet_id       = each.value
  security_groups = [aws_security_group.noteapp_efs_sg.id]

  depends_on = [ aws_subnet.noteapp_subnet ]
}