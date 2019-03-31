module Services
  # Service to get the notifications linked to a connected player.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Notifications
    include Singleton

    # Gets the sorted and filtered list of notifications for the given session.
    # @param session [Arkaan::Authentication::Session] the session the player is connected with.
    # @return [Array<Arkaan::Notification>] the notifications linked to the player.
    def list(session, parameters)
      notifications = sorted_notifications(session)
      if parameters.has_key?('skip')
        notifications = notifications.skip(parameters['skip'].to_i)
      end
      if parameters.has_key?('limit')
        notifications = notifications.limit(parameters['limit'].to_i)
      end
      return notifications.to_a.map do |notification|
        {
          type: notification.type,
          data: notification.data,
          created_at: notification.created_at.utc.iso8601
        }
      end
    end

    private

    def sorted_notifications(session)
      return session.account.notifications.order_by(created_at: :desc)
    end
  end
end