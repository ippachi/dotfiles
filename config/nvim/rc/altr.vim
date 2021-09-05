call altr#remove_all()
call altr#define('lib/%.rb', 'apps/%.rb', 'test/%_spec.rb')
call altr#define('app/%.rb', 'spec/%_spec.rb')
call altr#define('app/controllers/%_controller.rb', 'spec/requests/%_spec.rb')
