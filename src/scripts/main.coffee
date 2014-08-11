plus_open = false

$(document).ready -> init()

log = (s) -> console.log s

init = ->
	log 'Storage engine: ' + $.jStorage.currentBackend()
	log 'Storage available: ' + $.jStorage.storageAvailable()

	$('#div_plus').click ->
		return
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
				saveMemo(String(currentTime), newMemo)
				displayMemo(currentTime, $.jStorage.get(currentTime), true)
				$('.span_new').animate {color: 'white'}, {duration: 600, complete: -> $('.span_new').removeClass 'span_new'}

	$('#input').autosize()

	$("#table_memos").on 'click', '.td_excerpt', (event) ->
		$('.textarea_excerpt', @).focus()

	$("#table_memos").on 'keydown', '.textarea_excerpt', (event) ->
		if event.keyCode is 13 and not event.shiftKey
			event.preventDefault()
			if $(@).val() != ''
				$(@).blur()

	$("#table_memos").on 'focusout', '.textarea_excerpt', ->
			memoID = $(@).attr 'data-id'
			updatedMemo = $.jStorage.get(memoID)
			updatedMemo['content'] = $(@).val()
			updatedMemo['updated'] = new Date().getTime()
			saveMemo(memoID, updatedMemo)

	$("#table_memos").on 'click', '.edit_x', ->
		id = $(@).parent().parent().parent().attr('data-id')
		deleteMemo id
		undisplayMemo id

	$("#table_memos").on 'click', '.edit_clip', ->
		$('textarea[data-id=' + $(@).attr('data-id') + ']').select()

	$("#table_memos").on 'click', '.edit_star', ->
		log 'star'

				
	#fill()
	loadMemos()

Memo = (content, updated) ->
	@content = content
	@updated = updated
	@previous = undefined
	@next = undefined

displayMemo = (time, memo, animate = false) ->
	div_edit = $('<div>', {class: 'div_edit'})
	edit_star = $('<div>', {'data-id': time, class: 'edit_star'})
	edit_x = $('<div>', {'data-id': time, class: 'edit_x'})
	edit_clip = $('<div>', {'data-id': time, class: 'edit_clip'})
	div_edit.append [edit_x, edit_star, edit_clip]

	td_arrow = $('<td>', {class: 'td_arrow'})
	td_arrow.append div_edit

	td_excerpt = $('<td>', {class: 'td_excerpt'})
	textarea_excerpt = $('<textarea>', {'data-id': time, class: 'textarea_excerpt'})
	textarea_excerpt.val memo['content']
	textarea_excerpt.autosize()
	td_excerpt.append textarea_excerpt

	td_date = $('<td>', {class: 'td_date'})
	td_date.append dateFromTime(time)

	tr = $('<tr>', {'data-id': time})
	if animate then tr.addClass 'tr_fresh'
	tr.append [td_arrow, td_excerpt, td_date]

	$('.span_new').css {opacity: Math.max 0.2, memo['updated'] / Date.now()}
	$('#table_memos').prepend tr
	$('.tr_fresh').animate {opacity: 1}, {duration: 400, complete: -> $('.tr_fresh').removeClass 'tr_fresh'}

undisplayMemo = (id) ->
	$("#table_memos > tbody > tr[data-id='" + id + "']").animate {opacity: 0}, {duration: 200, complete: -> $(@).hide()}

deleteMemo = (id) ->
	$.jStorage.deleteKey(id)

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
	log time
	$.jStorage.set(time, memo, {TTL: 99999999999})
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
