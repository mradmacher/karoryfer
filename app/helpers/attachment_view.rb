class AttachmentView < ResourceView
  def _path
    artist_album_attachment_path(resource.album.artist, resource.album, resource)
  end
end
