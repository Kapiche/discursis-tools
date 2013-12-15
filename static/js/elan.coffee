$(document).ready(() ->
    $('#elan-file-select').change((e) ->
        file = e.target.files[0]
        if _.str.endsWith(file.name, ".eaf")
            reader = new FileReader()
            reader.onload = () ->
                # Parse the xml file and load the template
                xmlDoc = $.parseXML( reader.result )
                $xml = $( xmlDoc )
                context = {
                    annotations: []
                }
                $xml.find('TIER').each(() ->
                    if $(@).children().length > 0
                        context.annotations.push({name: $(@).attr('TIER_ID')})
                )
                $('#elan-output').html(Handlebars.templates.annotations(context))

                # Handle clicking of the checknoxes
                $('input:checkbox').on('click', () ->
                    if $('input:checked').length > 0 then $('#elan-save-btn').removeAttr('disabled') else $('#elan-save-btn').attr('disabled', '')
                )

                # Generate and download the CSV file
                $('#elan-save-btn').click(() ->
                    $checked = $('input:checked')
                    if $checked.length < 1
                        alert('You haven\'t selected any tiers!')
                        return
                    text_to_save = "ANNOTATION_ID,Tier,speaker,text,Onset,Offset,ref\n"
                    times = {}
                    annotations = {}
                    annotations_time_index = []
                    # Build out times dict. Doing it like this for speeeeeed
                    $tier = $xml.find('TIME_SLOT').each(() ->
                        $slot = $(@)
                        times[$slot.attr('TIME_SLOT_ID')] = $slot.attr('TIME_VALUE')
                    )
                    # Now build our annotations
                    $checked.each(() ->
                        tier_name = $(@).val()
                        $tier = $xml.find('TIER[TIER_ID="' + tier_name + '"]')
                        $annotations = $tier.find('ANNOTATION > ALIGNABLE_ANNOTATION')
                        if $annotations.length > 0
                            $annotations.each(() ->
                                $annotation = $(@)
                                id = $annotation.attr('ANNOTATION_ID')
                                time_start = times[$annotation.attr('TIME_SLOT_REF1')]
                                console.log(id) if time_start is '10400'
                                time_end = times[$annotation.attr('TIME_SLOT_REF2')]
                                value = $annotation.children('ANNOTATION_VALUE').text()
                                index = parseInt(time_start, 10)
                                if annotations[index]
                                    annotations[index].push(_.str.join(',', _.str.quote(id), _.str.quote(tier_name), _.str.quote(tier_name), _.str.quote(value.replace(/"/g, '""')), time_start, time_end, "\n"))
                                else
                                    annotations[index] = [(_.str.join(',', _.str.quote(id), _.str.quote(tier_name), _.str.quote(tier_name), _.str.quote(value.replace(/"/g, '""')), time_start, time_end, "\n"))]
                                annotations_time_index.push(index) if index not in annotations_time_index
                            )
                        else
                            $annotations = $tier.find('ANNOTATION > REF_ANNOTATION').each(() ->
                                $annotation = $(@)
                                id = $annotation.attr('ANNOTATION_ID')
                                ref_id = $annotation.attr('ANNOTATION_REF')
                                value = $annotation.children('ANNOTATION_VALUE').text()

                                $ref_annotation = $xml.find('ALIGNABLE_ANNOTATION[ANNOTATION_ID="' + ref_id + '"]')
                                time_start = times[$ref_annotation.attr('TIME_SLOT_REF1')]
                                time_end = times[$ref_annotation.attr('TIME_SLOT_REF2')]
                                index = parseInt(time_start, 10)
                                if annotations[index]
                                    annotations[index].push(_.str.join(',', _.str.quote(id), _.str.quote(tier_name), _.str.quote(tier_name), _.str.quote(value.replace(/"/g, '""')), time_start, time_end, _.str.quote(ref_id)+"\n"))
                                else
                                    annotations[index] = [_.str.join(',', _.str.quote(id), _.str.quote(tier_name), _.str.quote(tier_name), _.str.quote(value.replace(/"/g, '""')), time_start, time_end, _.str.quote(ref_id)+"\n")]
                                annotations_time_index.push(index) if index not in annotations_time_index
                            )
                    )
                    # Now build the text
                    annotations_time_index.sort((a, b) -> a-b)
                    for item in annotations_time_index
                        text_to_save += annotation for annotation in annotations[item]
                    blob = new Blob([text_to_save], {type: "text/csv;charset=utf-8"})
                    saveAs(blob, _.str.rtrim(file.name, ".eaf") + ".csv")
                )

            # Finally, read the file
            reader.readAsText(file)
        else
            alert('That doesn\'t appear to be an EAF file.\n\nPlease choose a file that ends with ".eaf".')
    )
)