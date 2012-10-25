#################################################
# Sample recipe
#################################################
package "git" do
  action :install
  not_if "rpm -q git"
end

