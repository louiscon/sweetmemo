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

	$('#input').keydown (event) ->
		if event.keyCode is 13
			event.preventDefault()
			if $(@).val() != ''

				memo = $(@).val()
				date = formatDate()
				time = new Date().getTime()

				$(@).val('')

				newMemo memo, date
				saveMemo memo, time
				

	$('table').on 'mouseover', '.td_excerpt', ->
		$(@).addClass("td_excerpt_mouseover")
		$(@).next().addClass('td_date_mouseover')

	$('table').on 'mouseleave', '.td_excerpt', ->
		$(@).removeClass('td_excerpt_mouseover')
		$(@).next().removeClass('td_date_mouseover')

	loadMemos()

newMemo = (memo, date) ->
	td_memo = $('<td>', {class: 'td_excerpt'}).append $('<span>', {class: 'span_new'}).append memo
	td_date = $('<td>', {class: 'td_date'}).append $('<span>', {class: 'span_new'}).append date

	tr = $('<tr>')
	tr.append td_memo
	tr.append td_date
	$('#table_memos > tbody > tr').eq(0).after tr

	$('.span_new').animate {color: 'white'}, {duration: 600, complete: -> $('.span_new').removeClass 'span_new'}

fill = ->
	for i in [0..50] by 1
		memo = makeid()

		td_excerpt = $('<td>', {class: 'td_excerpt'})
		td_excerpt.append memo

		td_date = $('<td>', {class: 'td_date'})
		td_date.append '27/07/2014'

		tr = $('<tr>')
		tr.append td_excerpt
		tr.append td_date

		$("#table_memos").append tr

formatDate = (today = undefined) ->
	if today is undefined then today = new Date()
	dd = today.getDate()
	mm = today.getMonth() + 1
	yyyy = today.getFullYear()
	dd = "0" + dd  if dd < 10
	mm = "0" + mm  if mm < 10
	today = mm + "/" + dd + "/" + yyyy

loadMemos = ->
	for time, memo of $.cookie()

		td_excerpt = $('<td>', {class: 'td_excerpt'})
		td_excerpt.append memo

		td_date = $('<td>', {class: 'td_date'})
		td_date.append formatDate(new Date(+time))

		tr = $('<tr>')
		tr.append td_excerpt
		tr.append td_date

		$("#table_memos").append tr

saveMemo = (memo, time) ->
	sTime = String(time)
	$.cookie sTime, memo

fill = ->
	for i in [0..50] by 1
		memo = makeid()

		td_excerpt = $('<td>', {class: 'td_excerpt'})
		td_excerpt.append memo

		td_date = $('<td>', {class: 'td_date'})
		td_date.append '27/07/2014'

		tr = $('<tr>')
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
