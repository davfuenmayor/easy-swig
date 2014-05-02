module EasySwig

  class Logger
    class << self

      def doxy_log dir
        file = File.open("#{dir}/doxygen.log", File::WRONLY | File::APPEND | File::CREAT)
        @doxy_log ||= ::Logger.new(file)
      end

      def log msg
        @gen_log.info msg
      end

      def gen_log dir=nil
        @gen_log ||= ::Logger.new(File.open("#{dir}/generate.log", File::WRONLY | File::APPEND | File::CREAT))
      end

      def node_log dir=nil
        @gen_log
      end

      def csv_log dir
        @csv_log ||= ::Logger.new(File.open("#{dir}/generate.log", File::WRONLY | File::APPEND | File::CREAT))
      end

      def swig_log dir
        @swig_log ||= ::Logger.new(File.open("#{dir}/swig.log", File::WRONLY | File::APPEND | File::CREAT))
      end

      def close_logs
      end
    end

  end
end