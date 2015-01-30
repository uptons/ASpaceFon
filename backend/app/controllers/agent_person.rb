class ArchivesSpaceService < Sinatra::Base

  Endpoint.post('/agents/people')
    .description("Create a person agent")
    .params(["agent", JSONModel(:agent_person), "The record to create", :body => true])
    .permissions([:update_agent_record])
    .returns([200, :created],
             [400, :error]) \
  do
    handle_create(AgentPerson, params[:agent])
  end


  Endpoint.get('/agents/people')
    .description("List all person agents")
    .params()
    .paginated(true)
    .permissions([])
    .returns([200, "[(:agent_person)]"]) \
  do
    handle_listing(AgentPerson, params)
  end


  Endpoint.post('/agents/people/:id')
    .description("Update a person agent")
    .params(["id", :id],
            ["agent", JSONModel(:agent_person), "The updated record", :body => true])
    .permissions([:update_agent_record])
    .returns([200, :updated],
             [400, :error]) \
  do
    handle_update(AgentPerson, params[:id], params[:agent])
  end


  Endpoint.get('/agents/people/:id')
    .description("Get a person by ID")
    .params(["id", Integer, "ID of the person agent"],
            ["resolve", :resolve])
    .permissions([])
    .returns([200, "(:agent)"],
             [404, "Not found"]) \
  do
    json_response(resolve_references(AgentPerson.to_jsonmodel(AgentPerson.get_or_die(params[:id])),
                                     params[:resolve]))
  end


  Endpoint.delete('/agents/people/:id')
    .description("Delete an agent person")
    .params(["id", Integer, "ID of the person agent"])
    .permissions([:delete_agent_record])
    .returns([200, :deleted]) \
  do
    handle_delete(AgentPerson, params[:id])
  end


end
