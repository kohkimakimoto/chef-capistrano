module Capistrano
   class Configuration
     module Roles

      attr_reader :chef_roles
      attr_reader :chef_role_suits

      def chef_role(which, *args, &block)

        # chef_rolesはタスクを動的生成するためのオブジェクト
        if !defined?(@chef_roles)
          @chef_roles = Hash.new { |h,k| h[k] = Role.new }
        end

        options = args.last.is_a?(Hash) ? args.pop : {}
        which = which.to_sym

        chef_roles[which] ||= Role.new

        chef_roles[which].push(block, options) if block_given?
        args.each { |host| chef_roles[which] << ServerDefinition.new(host, options) }

        # 合わせてcapistranoのroleを自動生成。動的生成するタスクのroleに使用する
        role(("chef_auto_role_" + which.to_s).to_sym, *args)
      end

      def chef_role_suit(which, *args)

        # chef_role_suitsは複数のchefタスクをまとめて実行させるタスクを動的生成するためのオブジェクト
        if !defined?(@chef_role_suits)
          @chef_role_suits = Hash.new
        end

        which = which.to_sym

        chef_role_suits[which] ||= args
      end

     end
   end
end