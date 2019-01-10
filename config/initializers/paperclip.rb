# When using uuid's for primary keys, the id_partition scheme can result
# in collisions, so we override this here to split the uuid along the dashes, and build
# the path from that (makes it easier at scale to download in bulk and push out)
Paperclip.interpolates :id_partition do |attachment, style_name| 
  case id = attachment.instance.id
  when Integer
    ("%09d" % id).scan(/\d{3}/).join("/")
  when String # Assuming that in our world only uuid's would be present
    id.split("-").join("/")
  else
    nil
  end
end
