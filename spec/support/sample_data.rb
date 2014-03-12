module SampleData
  def comet_settings_sample(basedir)
    {
      'email' => 'barry.zuckerkorn@example.com',
      'token' => 'abcdefghijklmnopqrstuv12345678',
      'server' => 'http://localhost:3000',
      'basedir' => basedir
    }
  end

  def katas_index_sample
    [{
        id: 1,
        name: "Calculator"
      },
      {
        id: 2,
        name: "Mini Golf"
      },
      {
        id: 3,
        name: "Sum Of Integers"
      }]
  end
end
