require 'prawn/table'

pdf.font_families["DejaVuSans"] = {
  normal: "vendor/assets/fonts/dejavu-fonts-ttf-2.35/ttf/DejaVuSans.ttf",
  bold: "vendor/assets/fonts/dejavu-fonts-ttf-2.35/ttf/DejaVuSans-Bold.ttf"
}

pdf.repeat(:all) do
  pdf.bounding_box([-pdf.bounds.absolute_left, pdf.cursor + 36],
                     width: pdf.bounds.absolute_left + pdf.bounds.absolute_right,
                     height: 40) do
    pdf.fill_color "bcf9c7"
    pdf.fill_rectangle([pdf.bounds.left, pdf.bounds.top],
                    pdf.bounds.right,
                    pdf.bounds.top - pdf.bounds.bottom)
    pdf.fill_color "000000"

    pdf.move_down(10)

    pdf.indent(30) do
      pdf.image "#{Rails.root}/app/assets/images/logo-xsmall.png"
    end
  end

  pdf.stroke_color "7ec060"
  pdf.stroke_horizontal_line(-36, pdf.bounds.width + 36, at: pdf.cursor)
  pdf.stroke_color "000000"
end

pdf.bounding_box [pdf.bounds.left, pdf.bounds.top-30], width: pdf.bounds.width, height: pdf.bounds.height-40 do

  pdf.font "DejaVuSans"

  pdf.font("DejaVuSans", style: :bold, size: 24) do
    pdf.text @petition.name, color: "1a9931"
  end
  pdf.move_down 20

  pdf.font("DejaVuSans", style: :bold) do
    pdf.text t('show.petition.we'), color: "4fa6d0"
  end
  pdf.text @petition.initiators
  pdf.move_down 10

  pdf.font("DejaVuSans", style: :bold) do
    pdf.text t('show.petition.observe'), color: "4fa6d0"
  end
  pdf.text @petition.statement
  pdf.move_down 10

  pdf.font("DejaVuSans", style: :bold) do
    pdf.text t('show.petition.request'), color: "4fa6d0"
  end
  pdf.text @petition.request
  pdf.move_down 30

  pdf.text "#{@signatures.size} ondertekeningen."
  pdf.move_down 10

  items = [[:person_name, :person_city, :person_function, :confirmed_at].collect{ |field| Signature.human_attribute_name(field) }]
  # items += @signatures.pluck(:person_name, :person_city, :person_function, :person_street)
  items += @signatures.map do |signature|
            [
              signature.person_name,
              signature.person_city,
              signature.person_function,
              l(signature.confirmed_at.to_date)
            ]
          end

  pdf.table(items,
            row_colors: ["FFFFFF", "EEEEEE"],
            cell_style: { size: 10, borders: [] },
            header: true) do |table|
            table.row(0).font = "DejaVuSans"
            table.row(0).font_style = :bold
            table.row(0).background_color = "4fa6d0"
            table.row(0).text_color = "ffffff"
  end

end

pdf.number_pages "Pagina <page> van <total>", at: [0, 0], size: 8
