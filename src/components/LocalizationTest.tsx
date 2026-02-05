import React from "react";
import { useTranslation } from "react-i18next";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { LanguageSwitch } from "./LanguageSwitch";

export const LocalizationTest: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="p-8">
      <Card className="p-6 max-w-2xl mx-auto">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold">{t('app.name')}</h2>
          <LanguageSwitch />
        </div>

        <div className="space-y-4">
          <div>
            <h3 className="text-lg font-semibold mb-2">{t('app.welcome')}</h3>
            <p className="text-gray-600">{t('app.description')}</p>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <Card className="p-4">
              <h4 className="font-medium">{t('navigation.agents')}</h4>
              <p className="text-sm text-gray-500">{t('status.loading')}</p>
            </Card>
            <Card className="p-4">
              <h4 className="font-medium">{t('navigation.projects')}</h4>
              <p className="text-sm text-gray-500">{t('status.ready')}</p>
            </Card>
          </div>

          <div className="flex gap-2">
            <Button>{t('common.save')}</Button>
            <Button variant="outline">{t('common.cancel')}</Button>
          </div>
        </div>
      </Card>
    </div>
  );
};