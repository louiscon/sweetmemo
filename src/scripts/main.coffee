plus_open = false

$(document).ready -> init()

init = ->

	#$('#plus').mouseover ->
		#$(@).animate {rotation: 45}, {duration: 100, step: (now, fx) -> $('#plus').css "-webkit-transform", "rotate(" + now + "deg)"}

	#$('#plus').mouseleave ->
		#$(@).animate {rotation: 0}, {duration: 100, step: (now, fx) -> $('#plus').css "-webkit-transform", "rotate(" + now + "deg)"}

	$('#plus').click ->
		right = (if plus_open then '0px' else '100px')
		$(@).animate {right: right}, {duration: 200, easing: 'easeOutQuart'}
		plus_open = not plus_open

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
