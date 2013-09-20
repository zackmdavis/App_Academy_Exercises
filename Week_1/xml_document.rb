class XmlDocument

# can't figure out how to do the indentation :(

  def method_missing(meth, *args, &block)
    attributes = ''
    if !args.empty?
      attributes += ' '+String(args[0].keys[0])+"='"+String(args[0][args[0].keys[0]])+"'"
    end
    open_tag = '<'+String(meth)+attributes+'>'
    close_tag = '</'+String(meth)+'>'
    solo_tag = '<'+String(meth)+attributes+'/>'
    if block
      return open_tag + block.call() + close_tag
    else
      return solo_tag
    end
  end
end
