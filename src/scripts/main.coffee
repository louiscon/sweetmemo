plus_open = false

$(document).ready -> init()

init = ->

	$('#div_plus').click ->
		right = (if plus_open then '5%' else '105%')
		width = (if plus_open then '0' else '100%')
		angle = (if plus_open then '0' else '-45deg')
		border = (if true then 'None' else '1px solid white')
		easing = 'easeOutCirc'
		duration = 700

		$(@).animate {right: right}, {duration: duration, easing: easing, queue: false}
		$(@).animate {rotation: angle}, {duration: duration, step: (now, fx) -> $('#div_plus').css "-webkit-transform", "rotate(" + now + "deg)"}
		$('#input').animate {width: width}, {duration: duration, easing: easing, complete: -> $('#input').css {'border': border} }
		plus_open = not plus_open

	$('#div_plus').mouseover ->
		if plus_open
			$(@).children().addClass 'cross_mouseover'
		else
			$(@).children().addClass 'plus_mouseover'

	$('#div_plus').mouseleave ->
		$(@).children().removeClass 'cross_mouseover'
		$(@).children().removeClass 'plus_mouseover'

	$('table').on 'mouseover', '.excerpt', ->
		$(@).addClass("excerpt_mouseover")
		$(@).next().addClass('date_mouseover')
		$(@).prev().addClass('arrow_mouseover')

	$('table').on 'mouseleave', '.excerpt', ->
		$(@).removeClass('excerpt_mouseover')
		$(@).next().removeClass('date_mouseover')
		$(@).prev().removeClass('arrow_mouseover')

	fill()

fill = ->
	for i in [0..50] by 1
		memo = makeid()

		td_arrow = $('<td>', {class: 'arrow'})
		td_arrow.append '>'

		td_excerpt = $('<td>', {class: 'excerpt'})
		td_excerpt.append memo

		td_date = $('<td>', {class: 'date'})
		td_date.append '27/07/2014'

		tr = $('<tr>')
		#tr.append td_arrow
		tr.append td_excerpt
		tr.append td_date

		$("#table_memos").append tr


`function makeid()
{
    var text = "";
    var possible = "abcdefghijklmnopqrstuvwxyz            ";

    for( var i=0; i < 600; i++ )
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}`

log = (s) -> console.log s
