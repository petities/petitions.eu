require 'prawn/table'

pdf.text "Petition: #{@petition.name}"
pdf.text "Id: #{@petition.id}"
pdf.text "Signatures count: #{@all_signatures.size}"

items = [['Name', 'City', 'Visible', 'Confirmed at']]
items += @all_signatures.map do |signature|
          [
            signature.person_name,
            signature.person_city,
            signature.visible.to_s,
            signature.confirmed_at.to_s
          ]
        end

pdf.table items,  
          row_colors: ["FFFFFF", "EEEEEE"],
          cell_style: { size: 10 },
          header: true