# irb test: Image.new(:resource => File.new('/home/alexey/grass.png', "r"))

class Image < Upload
  has_attached_file :resource, Upload.attachment_definitions[:resource].merge(

      #   For example, if you want your thumbnails to be exactly 100x100 pixels,
      #   but you don't want the image to be distorted (e.g., squished) and
      #   instead crop off any part of the image that doesn't fit proportionally,
      #   you would add the "#" symbol to the end of your size definition.
      #   Defining the first dimension (width) and using the ">" symbol after it  means that the image will be reduced
      #   in size such that the width is made to be 600 pixels wide, and the height is simply adjusted proportionally.

      styles: {
          thumb:      '500x500#',
          #croppable:  '300x300#',
          #big:        '800x800#>'
      },

      default_style:    :thumb,
      #convert_options: { regular: '-quality 100' }
  )

  validates_attachment  :resource,
                        :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
                        :size => { :in => 0..3.megabytes }
end
