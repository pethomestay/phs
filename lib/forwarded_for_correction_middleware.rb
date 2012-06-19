class ForwardedForCorrectionMiddleware
  def initialize(app)
    @app = app
  end
  
  def call(env)
    dup._call(env)
  end
  
  def _call(env)
    if env['HTTP_X_FORWARDED_FOR']
      env['HTTP_X_FORWARDED_FOR'] = env['HTTP_X_FORWARDED_FOR'].split(',').first
    end
    
    @app.call(env)
  end
end
