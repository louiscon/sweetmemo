plus_open = false

$(document).ready -> init()

log = (s) -> console.log s

init = ->
	log 'Storage engine: ' + $.jStorage.currentBackend()
	log 'Storage available: ' + $.jStorage.storageAvailable()

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

	$('#logo1').click ->
		$.jStorage.flush()

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
				content = $(@).val()
				$(@).val('')
				currentTime = new Date().getTime()
				newMemo = new Memo(content, currentTime)
				saveMemo(currentTime, newMemo)
				displayMemo(currentTime, $.jStorage.get(currentTime), true)
				$('.span_new').animate {color: 'white'}, {duration: 600, complete: -> $('.span_new').removeClass 'span_new'}
				

	$('table').on 'mouseover', '.td_excerpt', ->
		$(@).addClass("td_excerpt_mouseover")
		$(@).next().addClass('td_date_mouseover')

	$('table').on 'mouseleave', '.td_excerpt', ->
		$(@).removeClass('td_excerpt_mouseover')
		$(@).next().removeClass('td_date_mouseover')
	#fill()
	loadMemos()

Memo = (content, updated) ->
	@content = content
	@updated = updated
	@previous = undefined
	@next = undefined

displayMemo = (time, memo, animate = false) ->
	timePct = memo['updated'] / Date.now()
	opacity = Math.max 0.2, timePct
	newClass = if animate then ' span_new' else ''
	td_excerpt = $('<td>', {class: 'td_excerpt' + newClass})
	td_excerpt.append memo['content']
	td_date = $('<td>', {class: 'td_date' + newClass})
	td_date.append dateFromTime(time)
	tr = $('<tr>')
	tr.append td_excerpt
	tr.append td_date
	tr.css {opacity: opacity}
	$('#table_memos > tbody > tr').eq(0).after tr

dateFromTime = (time) ->
	formatDate(new Date(+time))

formatDate = (date) ->
	dd = date.getDate()
	mm = date.getMonth() + 1
	yyyy = date.getFullYear()
	dd = "0" + dd if dd < 10
	mm = "0" + mm if mm < 10
	date = mm + "/" + dd + "/" + yyyy

loadMemos = ->
	for key in $.jStorage.index()
		displayMemo key, $.jStorage.get(key)

saveMemo = (time, memo) ->
	log 'Saving memo: ' + time + ': ' + memo['content']
	$.jStorage.set(String(time), memo, {TTL: 99999999999})
	log 'Saved memo: ' + time + ': ' + $.jStorage.get(time)['content']
	log 'Stored data size: ' + $.jStorage.storageSize()

fill = ->
	for i in [0..50] by 1
		memo = makeid()
		td_excerpt = $('<td>', {class: 'td_excerpt'})
		td_excerpt.append memo
		td_date = $('<td>', {class: 'td_date'})
		now = Date.now()
		randomTime = Math.floor(Math.random() * now)
		timePct = randomTime / now
		opacity = Math.max 0.2, timePct
		randomDate = formatDate(new Date(randomTime))		
		td_date.append randomDate
		td_excerpt.css {opacity: opacity}
		td_date.css {opacity: opacity}
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
