require "../languages/EN.cr"
module FormatterUtility

    def translateLanguage(label, language = "EN")
        if translations[label] != Nil
            return translations[label]
        else
            return label
        end
    end
end
