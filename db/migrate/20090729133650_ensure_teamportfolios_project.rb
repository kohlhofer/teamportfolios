class EnsureTeamportfoliosProject < ActiveRecord::Migration
  def self.up
    puts "ok: #{ENV['RAILS_ENV']}"
    return unless ENV["RAILS_ENV"]=="development" || ENV["RAILS_ENV"].blank?
    puts "ok"
    project = Project.find_by_name('teamportfolios')
    puts "project: #{project}"
    if project.nil?
      project = User.find_by_login('tim').projects.create!(:name=>'teamportfolios',:title=>'Team Portfolios', :strapline=>'This website', :description=>'details about team portfolios')
      User.find_by_login('alex').projects << project
      project.update_attributes(:name=>'teamportfolios')
      puts "project: #{project}"
    end
  end

  def self.down
  end
end
