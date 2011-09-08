# Place all the behaviors and hooks related to the matching contdoller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $.ajax({
    url: "/equipment/models.js",
    dataType: 'json',
    success: (models) ->
      fill_table(models)
  })

  fill_table = (models) ->
    kinds = build_fubar models
    for kind, companies of kinds
      $('#available_models > tbody:last').append(build_kind_row(kind, companies))

    # register callbacks
    $('tr.kind a').click (e) ->
      #$(".company.#{e.target.id}").toggleClass('hidden')
      $(".company.#{e.target.id}").fadeToggle()
      e.preventDefault()

    $('tr.company a').click (e) ->
      #$(".model.#{e.target.id}").toggleClass('hidden')
      $(".model.#{e.target.id}").fadeToggle()
      e.preventDefault()

  build_fubar = (models) ->
    big = {}
    kinds = []
    models.forEach (e) -> kinds.push(e.kind) if(kinds.indexOf(e.kind) == -1)
    kinds.sort().forEach (kind) ->
      big[kind] = {}
      companies = []
      models.filter((model) -> model.kind == kind).forEach (model) ->
        companies.push(model.company) if(companies.indexOf(model.company) == -1)
      companies.sort().forEach (company) ->
        big[kind][company] = models.filter((model) ->
          model.kind == kind and model.company == company
        )
    return big

  build_kind_row = (kind, companies) ->
    row = "<tr class='kind'><td></td><td></td><td></td><td><a id='#{classify(kind)}' href='#'>#{kind}</a></td></tr>"
    row += build_company_row(kind, company, models) for company, models of companies
    return row

  build_company_row = (kind, company, models) ->
    row = "<tr class='hidden company #{classify(kind)}'><td></td><td></td><td><a id='#{classify(company)}' href='#'>#{company}</a></td><td>#{kind}</td></tr>"
    row += build_model_row(model) for model in models
    return row

  build_model_row = (model) ->
    options = ''
    for num in [0..model.total]
      options += "<option>#{num}</option>"
    select = "<select class='mini'>#{options}</select>"
    row =  "<td>#{select}</td>"
    row += "<td>#{model.model}</td>"
    row += "<td>#{model.company}</td>"
    row += "<td>#{model.kind}</td>"
    return "<tr class='hidden model #{classify(model.kind)} #{classify(model.company)}'>#{row}</tr>"

  classify = (str) ->
    return str.toLowerCase().trim().replace /\W/gi, '_'

