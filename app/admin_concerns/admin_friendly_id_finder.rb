module AdminFriendlyIdFinder
  def self.included(dsl)
    dsl.controller do
      def find_resource
        scoped_collection.friendly.find(params[:id])
      end
    end
  end
end
