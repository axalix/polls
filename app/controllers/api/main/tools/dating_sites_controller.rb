class Api::Main::Tools::DatingSitesController < Api::Controller
  skip_before_filter :authentication, only: [:index]

  def index
    @dating_sites = scoped_dating_sites
  end

  protected

  def scoped_dating_sites
    DatingSite.visible
  end
end
