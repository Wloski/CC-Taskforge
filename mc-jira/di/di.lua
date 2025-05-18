local DI = { providers = {} }

function DI.register(name, provider)
    DI.providers[name] = provider
end

function DI.get(name)
    return DI.providers[name] and DI.providers[name]()
end

return DI