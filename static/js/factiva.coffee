$(document).ready(() ->

    $('#factiva-file-select').change((e) ->
        # Make sure all checkboxes are disabled
        $('input[type=checkbox]').attr('disabled', '').prop('checked', false)
        file = e.target.files[0]
        if _.str.endsWith(file.name, ".html")
            reader = new FileReader()
            reader.onload = () ->
                # Parse the html file and load the template
                $htmlDoc = $( reader.result )

                # Extract articles
                articles = []
                codes = []
                $('.article table', $htmlDoc).each(() ->
                    article = {}
                    $('tr', @).each(() ->
                        $cells = $('td', @)
                        $code = $('b', $cells[0]).text().toLowerCase()
                        article[$code] = $($cells[1]).text()
                        if $.inArray($code, codes) < 0
                            codes.push($code)
                    )
                    articles.push(article)
                )

                # Make select boxes visible
                $(codes).each(() ->
                    $("input[name='" + @.toLowerCase() + "']").removeAttr('disabled').prop('checked', true)
                )
                $('.output-container').show()

                # Generate and download CSV
                # Generate and download the CSV file
                $('#factiva-save-btn').click(() ->
                    $checked = $('input:checked')
                    if $checked.length < 1
                        alert('You haven\'t selected any fields!')
                        return
                    # Pull field codes we are using
                    codes = []
                    text_code = undefined
                    $checked.each(() ->
                        codes.push($(@).attr('name'))
                    )
                    if $.inArray("td", codes) >= 0
                        text_code = "td"
                    else if $.inArray("ls", codes) >= 0
                        text_code = "ls"
                    else if $.inArray("hd", codes) >= 0
                        text_code = "hd"
                    else
                        alert("You must select one of tp, ls or hd to \ninclude as the text field in the Discursis CSV.")
                        return
                    codes = $.grep(codes, (i) ->
                        return i != text_code
                    )

                    # Generate text for CSV
                    text_to_save = "text," + _.str.join(",", codes)
                    console.log(text_code)
                    for article in articles
                        if article[text_code]
                            line = _.str.quote(article[text_code].replace(/"/g, '""'))
                            for code in codes
                                if article[code]
                                    line = _.str.join(",", line, _.str.quote(article[code].replace(/"/g, '""')))
                                else
                                    line += ','
                            text_to_save = _.str.join("\n", text_to_save, line)

                    blob = new Blob([text_to_save], {type: "text/csv;charset=utf-8"})
                    saveAs(blob, _.str.rtrim(file.name, ".html") + ".csv")
                )

            # Finally, read the file
            reader.readAsText(file)
        else
            alert('That doesn\'t appear to be a HTML file.\n\nPlease choose a file that ends with ".html".')
    )
)