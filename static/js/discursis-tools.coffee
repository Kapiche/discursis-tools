$(document).ready(() ->
    # Add links where needed
    $('.div-button').each(() ->
        $(this).click(() ->
            window.location = $(this).attr('dtlink')
        )
    )
)
