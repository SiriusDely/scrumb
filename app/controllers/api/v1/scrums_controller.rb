class Api::V1::ScrumsController < ApiController
  before_action :set_scrum, only: [:show, :update, :destroy]
  # GET /scrums
  def index
    @scrums = @current_user.scrums
    render json: @scrums.to_json
  end

  # GET /scrums/:id
  def show
    render json: @scrum.to_json(:include => { :tasks => { :only => [:id, :title] } })
  end

  def today
    @scrum = Scrum.find(params[:id])
    @day = @scrum.days.first

    data = @day.as_json only: :created_at
    data[:scrum] = @scrum.as_json :only => [:id, :title, :description]
    data[:users] = []

    @day.rotations.includes(:user, task: :owner).group_by(&:user).each do |user, rotations|
      user = user.as_json :only => [:id, :email], :methods => :avatar_url
      user[:rotations] = []

      rotations = rotations.group_by(&:type).sort do |a, b|
        Rotation::TYPES.index(a[0]) <=> Rotation::TYPES.index(b[0])
      end

      rotations.each do |type, rotation|
        rttn = { :type => type, :name => type.to_s.capitalize }
        rttn[:name] = 'Helps Needed' if type == :tomorrow
        rttn[:tasks] = []
        rotation.each do |r|
          rttn[:tasks] << (r.task.as_json :only => [:id, :title], :include => {
            :owner => {
              :only => [:id, :email], :methods => :avatar_url
            }
          })
        end
        user[:rotations] << rttn
      end
      data[:users] << user
    end

    render json: data
  end

  def create
    @scrum = Scrum.create!(scrum_params)
    json_response(@scrum, :created)
  end

  def update
    @scrum.update(scrum_params)
    head :no_content
  end

  def destroy
    @scrum.destroy
    head :no_content
  end

  private

  def scrum_params
    # whitelist params
    params.permit(:title, :description)
  end

  def set_scrum
    @scrum = Scrum.find(params[:id])
  end
end
