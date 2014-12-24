@Ticket =
  assign: (id)->
    Spinner.show()
    $.ajax('/tickets/' + id + '/assign', {
      type: 'post',
      success: (response)->
        Spinner.hide()
        $('#ticket_' + id).replaceWith(response);
    })

  reply: (id)->
    Spinner.show()
    ticketContainer = $('#edit_ticket_' + id);
    formGroup = ticketContainer.children('.form-group')
    textArea = formGroup.children('#reply')
    $.ajax('/tickets/' + id + '/reply', {
      data: '{"message":"' + textArea.val() + '"}',
      type: 'post',
      contentType: 'application/json; charset=utf-8',
      success: (response)->
        Spinner.hide()
        $('#ticket-section-' + id).replaceWith(response);
    })

  edit: (id) ->
    ticketContainer = $('#edit_ticket_' + id);
    formGroup = ticketContainer.children('.form-group')
    formGroup.children('.edit_ticket_button').hide()
    formGroup.children('.update_ticket_button').show()
    formGroup.children('.cancel_link').show()
    formGroup.children('.text').prop('disabled', false)

  update: (id) ->
    Spinner.show()
    ticketContainer = $('#edit_ticket_' + id);
    formGroup = ticketContainer.children('.form-group')
    textArea = formGroup.children('.text')
    self = @
    $.ajax('/tickets/' + id, {
      data: '{"question":"' +  textArea.val() + '"}',
      type: 'put',
      contentType: 'application/json; charset=utf-8',
      success: ->
        Spinner.hide()
        self.cancelEdit(id)
    })

  cancelEdit: (id) ->
    ticketContainer = $('#edit_ticket_' + id);
    formGroup = ticketContainer.children('.form-group')
    formGroup.children('.edit_ticket_button').show()
    formGroup.children('.update_ticket_button').hide()
    formGroup.children('.cancel_link').hide()
    formGroup.children('.text').prop('disabled', true)

  answer: (id) ->
    ticketContainer = $('#ticket_' + id);
    divWithActions = ticketContainer.children('div')
    divWithActions.children('.answer_ticket_button').hide()
    divWithActions.children('.ticket-answer').show()
    divWithActions.children('.send_ticket_button').show()
    divWithActions.children('.cancel_link').show()

  sendAnswer: (id) ->
    Spinner.show()
    ticketContainer = $('#ticket_' + id)
    textArea = ticketContainer.children('div').children('.ticket-answer').children('#answer')
    self = @
    $.ajax('/tickets/' + id + '/answer', {
      data: '{"answer":"' + textArea.val() + '"}',
      type: 'post',
      contentType: 'application/json; charset=utf-8',
      success: ->
        Spinner.hide()
        self.cancelAnswer(id)
    })

  cancelAnswer: (id) ->
    ticketContainer = $('#ticket_' + id);
    divWithActions = ticketContainer.children('div')
    divWithActions.children('.answer_ticket_button').show()
    divWithActions.children('.ticket-answer').hide()
    divWithActions.children('.send_ticket_button').hide()
    divWithActions.children('.cancel_link').hide()

  close: (id) ->
    Spinner.show()
    $.ajax('/tickets/' + id + '/close', {
      type: 'post',
      success: (response)->
        Spinner.hide()
        $('#ticket-section-' + id).replaceWith(response);
    })

  search: (input) ->
    Spinner.show()
    $.ajax('/tickets/search', {
      data: '{"query":"' + $(input).val() + '"}',
      type: 'post',
      contentType: 'application/json; charset=utf-8',
      success: (response)->
        Spinner.hide()
        $('#question-list').html(response);
    })